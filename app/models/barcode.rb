require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'barby/outputter/html_outputter'

class Barcode
  def initialize(code)
    @barcode = Barby::Code128B.new(code)
    @code = code
  end

  def write_image(height:20, margin:0, path:"public/assets/images", overwrite:false)
    filepath = path + "/#{@code.upcase}.PNG"
    if overwrite
      File.open(filepath,'wb'){|file| file.write @barcode.to_png(height:height,margin:margin)}
    else
      File.open(filepath,'wb'){|file| file.write @barcode.to_png(height:height,margin:margin)} unless File.exist?(filepath)
    end
  end
end
