# frozen_string_literal: true

# Получение данных ЭЛН
class Fss::GetLnData < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/get_ln_data.xml")
  end

  def call
    response = client.call(:get_ln_data, message: xml_data)
    pp response.body
  end
end

# {:get_ln_data_response=>
#    {:request_id=>"1878925f-3e87-49c7-b811-ffa0ef1b2fc0",
#     :status=>"0",
#     :mess=>
#       "ЭЦП неверна. INVALID_SIGNATURE ЭП недействительна. Обратитесь к разработчику программного обеспечения, на котором осуществлялось подписание данных.",
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>
#       "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"},
#  :"@wsu:id"=>"OGRN_1027739443236"}

