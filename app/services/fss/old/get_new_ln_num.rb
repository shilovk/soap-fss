# frozen_string_literal: true

# Запрос генерации нового номера ЭЛН
# Fss::GetNewLnNum.new(actor: '1027739443236', ogrn: '1027500716143').call
class Fss::GetNewLnNum < Fss::Application
  def call
    response = client.call(:get_new_ln_num, message: envelop)
    pp response.body
  end

  private

  def envelop
    @envelop = Fss::Envelop.new(actor: actor, ogrn: ogrn, operation: :get_new_ln_num).call
    # @envelop = File.read("#{Rails.root}/public/xml/get_new_ln_num.xml")
  end
end

# {:get_new_ln_num_response=>
#    {:request_id=>"81a39191-7fcf-4143-9064-71b3fa385f88",
#     :status=>"0",
#     :mess=>
#       "ЭЦП неверна. INVALID_SIGNATURE ЭП недействительна. Обратитесь к разработчику программного обеспечения, на котором осуществлялось подписание данных.",
#     :data=>nil,
#     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
#     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
#     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
#     :"@xmlns:ns4"=>
#       "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
#     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
#     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"},
#  :"@wsu:id"=>"OGRN_1027739443236"}
