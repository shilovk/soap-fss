# frozen_string_literal: true

# Запрос генерации нового пула номеров ЭЛН
class Fss::GetNewLnNumRange < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/get_new_ln_num_range.xml")
  end

  def call
    response = client.call(:get_new_ln_num_range, message: xml_data)
    pp response.body
  end
end

# {:get_new_ln_num_range_response=>
#    {:request_id=>"3869dcb4-e5cc-4daf-9664-7b189e3a88fd",
#     :status=>"0",
#     :mess=>"С 01.01.2020 введен запрет на использование сертификатов ГОСТ 2001. Для работы с ЭЛН необходимо использовать сертификаты, сформированные по ГОСТ 2012",
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"}}
