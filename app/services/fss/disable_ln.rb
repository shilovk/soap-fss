# frozen_string_literal: true

# Запрос отмены ЭЛН
class Fss::DisableLn < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/disable_ln.xml")
  end

  def call
    response = client.call(:disable_ln, message: xml_data)
    pp response.body
  end
end

# {:disable_ln_response=>
#    {:request_id=>"6b812018-8210-4972-876c-6ed12838f26d",
#     :status=>"0",
#     :mess=>"ЭЦП неверна. INVALID_SIGNATURE ЭП недействительна. Обратитесь к разработчику программного обеспечения, на котором осуществлялось подписание данных.",
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"},
#  :"@wsu:id"=>"OGRN_1027739443236"}
