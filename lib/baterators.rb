require 'YAML'

module Baterators
  @config = nil
  PLZ_CONFIGURE = 'Please configure Baterators'

  # Function to use specific config file. If it loads successfully
  # generate functions using the value provided for each key in the yml.
  def use_config_file(path)
    begin
      @config = YAML.load_file(path)
    rescue Errno::ENOENT
      @config = nil
      return "Couldn't load file, please check the supplied path"
    else
      @config = YAML.load_file(path)
      self.create_emoji_methods
    end # begin block
  end # use_config_path

  protected
  # small function to return utf-8 character from a provided utf code string
  def utf_code_to_str(utf_code)
    u_hex = utf_code[2..-1]
    return ["#{u_hex}".to_i(16)].pack 'U'
  end

  # Dynamically create class methods for each utf-8 code found in the YML file
  def create_emoji_methods
    @config.each_pair do |key, value|
      emoji = self.utf_code_to_str(key)
      emoji.to_sym
      define_singleton_method emoji do
        if @config[key][:value] == nil || @config[key][:value].empty?
          return PLZ_CONFIGURE
        else
          eval (@config[key][:value])
        end # end if
    end # end define_singleton
    end # config.each_pair
  end # end create_emoji_methods
end # end module
