# frozen_string_literal: true

# Запрос ЭЛН по СНИЛС
class Fss::GetLnListBySnils < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/get_ln_list_by_snils.xml")
  end

  def call
    response = client.call(:get_ln_list_by_snils, message: xml_data)
    pp response.body
  end
end

# {:get_ln_list_by_snils_response=>
#    {:request_id=>"3ee1c17e-3bdf-4133-93b8-9105bc7b8802",
#     :status=>"0",
#     :mess=>"ЭЦП неверна. INVALID_SIGNATURE ЭП недействительна. Обратитесь к разработчику программного обеспечения, на котором осуществлялось подписание данных.",
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"},
#  :"@wsu:id"=>"OGRN_1027739443236"}
