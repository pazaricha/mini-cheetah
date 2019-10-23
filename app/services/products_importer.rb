require 'csv'
require 'open-uri'
require 'fileutils'

# Example remote file url 'https://paz-dummy-bucket.s3.eu-central-1.amazonaws.com/MOCK_DATA-(1).csv'

class ProductsImporter
  def initialize(remote_csv_url)
    @remote_csv_url = remote_csv_url
    @local_file_path = "tmp/csv_imports/#{Time.now.to_i}"
    @local_file_path_with_file_name = "#{@local_file_path}/products.csv"
  end

  def import
    create_local_folder

    download_file

    process

    delete_local_folder_and_file
  end

  private

  def create_local_folder
    FileUtils.mkdir_p(@local_file_path)
  end

  def download_file
    open(@local_file_path_with_file_name, 'wb') do |file|
      file << open(@remote_csv_url).read
    end
  end

  def process
    sum = 0
    CSV.foreach("#{Rails.root}/#{@local_file_path_with_file_name}", headers: true) do |row|
      sum += row['price_cents'].to_i
    end

    puts "Sum: #{sum}"
  end

  def delete_local_folder_and_file
    FileUtils.remove_dir(@local_file_path)
  end
end
