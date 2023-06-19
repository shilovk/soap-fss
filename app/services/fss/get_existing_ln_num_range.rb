# frozen_string_literal: true

# Запрос существующего пула ЭЛН
class Fss::GetExistingLnNumRange < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/get_existing_ln_num_range.xml")
  end

  def call
    response = client.call(:get_existing_ln_num_range, message: xml_data)
    pp response.body
  end
end

# nil
