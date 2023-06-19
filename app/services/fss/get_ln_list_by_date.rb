# frozen_string_literal: true

# Запрос ЭЛН по Дате
class Fss::GetLnListByDate < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/get_ln_list_by_date.xml")
  end

  def call
    response = client.call(:get_ln_list_by_date, message: xml_data)
    pp response.body
  end
end

# {:get_ln_list_by_date_response=>
#    {:request_id=>"4751d50a-5f02-4bb5-ba18-390004ac2462",
#     :status=>"0",
#     :mess=>"С 01.01.2020 введен запрет на использование сертификатов ГОСТ 2001. Для работы с ЭЛН необходимо использовать сертификаты, сформированные по ГОСТ 2012",
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"}}
