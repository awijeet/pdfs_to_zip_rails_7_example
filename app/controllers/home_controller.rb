class HomeController < ApplicationController

  def index
    @title = params[:title]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "index"
      end 
    end 
  end

  def download_zip
    require 'open-uri'
    require 'zip'
    current_time = Time.now.to_i.to_s
    FileUtils.mkdir_p("#{Rails.root}/tmp/#{current_time}")
    ["Sri Ram", "Sri Krishna", "Sri Kalki Dev"].each do |name|
      url = "http://localhost:3000/home/index.pdf?title=#{name}"
      current_time_stamp = Time.now.to_i.to_s
      file_name = name.parameterize+".pdf"                  
      file_path = Rails.root.join("tmp/#{current_time}", file_name)
      begin
        File.write(file_path, URI.open(url).read)
      end 
    end 
    
    Zip::File.open( "tmp/#{current_time}.zip", Zip::File::CREATE ) do |zip_file|
      Dir[ File.join( "tmp/#{current_time}", "**", "**" ) ].each do |file|
        zip_file.add( file.sub( "tmp/#{current_time}/", "" ), file )
      end
    end
    head :no_content 
  end 

end
