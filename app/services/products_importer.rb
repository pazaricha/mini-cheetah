require 'csv'
require 'open-uri'
require 'fileutils'

# Example remote file url 'https://paz-dummy-bucket.s3.eu-central-1.amazonaws.com/MOCK_DATA-(1).csv'

class ProductsImporter
  def initialize(remote_csv_url)
    @remote_csv_url = remote_csv_url
    @local_file_path = "tmp/csv_imports/#{Time.now.strftime('%Y%m%d%H%M%S')}"
    @local_file_path_with_file_name = "#{@local_file_path}/products.csv"
    @failures = []
  end

  def import
    Rails.logger.tagged('ProductsImporter') do
      create_local_folder

      download_file

      process

      if @failures.blank?
        delete_local_folder_and_file
      else
        failed_products_skus = @failures.map { |failed_product_hash| failed_product_hash[:sku] }

        Rails.logger.error "Some products creation has failed :( \n\n Failed products SKUs: #{failed_products_skus}.\n\n File to inspect: #{@local_file_path_with_file_name}"
      end
    end
  end

  private

  def create_local_folder
    Rails.logger.info "Creating folder: #{@local_file_path}"

    FileUtils.mkdir_p(@local_file_path)
  end

  def download_file
    Rails.logger.info "Downloading products csv from: #{@remote_csv_url} to: #{@local_file_path_with_file_name}"

    open(@local_file_path_with_file_name, 'wb') do |file|
      file << open(@remote_csv_url).read
    end
  end

  def process
    Rails.logger.info "Starting to process products"

    CSV.foreach("#{Rails.root}/#{@local_file_path_with_file_name}", headers: true) do |row|
      product_sku = row['sku (unique id)']
      next if product_sku.blank?

      Rails.logger.info "Processing product: #{product_sku}"

      if Product.exists?(sku: product_sku)
        Rails.logger.info "Skipping product: #{product_sku} because it already exists"
        next
      end

      producer = Producer.find_or_create_by(name: row['producer']) if row['producer'].present?

      product = Product.create(sku: product_sku) do |product|
        product.producer = producer
        product.name = row['product_name']
        product.price_cents = row['price_cents']
        product.barcode = row['barcode']
      end

      if product.errors.present?
        errors = product.errors.messages.to_sentence

        Rails.logger.error "Failed to create product: #{product.sku}. Errors: #{errors}"

        @failures << { sku: product.sku, errors: errors }
      else
        Rails.logger.info "Product: #{product.sku}. created successfully!"
      end


    end
  end

  def delete_local_folder_and_file
    Rails.logger.info "Deleting local file and folder: #{@local_file_path}"

    FileUtils.remove_dir(@local_file_path)

    Rails.logger.info 'All products imported successfully! :)'
  end
end
