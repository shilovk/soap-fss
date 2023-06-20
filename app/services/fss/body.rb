# frozen_string_literal: true

# Тело сообщения
class Fss::Body < Fss::Application
  def call
    body
  end

  private

  def body
    @body ||= <<-XML
      <soapenv:Body wsu:Id="OGRN_#{ogrn}">
        #{send(operation)}
      </soapenv:Body>
    XML
  end

  # {:get_new_ln_num_response=>
  #    {:request_id=>"4a7b757b-99e5-4245-ab75-0afe7077cd50",
  #     :status=>"0",
  #     :mess=>"ЭЦП неверна. INVALID_SIGNATURE ЭП недействительна. Обратитесь к разработчику программного обеспечения, на котором осуществлялось подписание данных.",
  #     :data=>nil,
  #     :@xmlns=>"http://www.fss.ru/integration/types/eln/mo/v01",
  #     :"@xmlns:ns2"=>"http://www.fss.ru/integration/types/eln/v01",
  #     :"@xmlns:ns3"=>"http://www.fss.ru/integration/types/eln/ins/v01",
  #     :"@xmlns:ns4"=>"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
  #     :"@xmlns:ns5"=>"http://www.fss.ru/integration/types/fault/v01",
  #     :"@xmlns:ns6"=>"http://www.fss.ru/integration/types/common/v01"},
  #  :"@wsu:id"=>"OGRN_1027739443236"}
  def get_new_ln_num
    @get_new_ln_num ||= <<-XML
      <v01:getNewLNNumRequest>
          <v01:ogrn>#{ogrn}</v01:ogrn>
      </v01:getNewLNNumRequest>
    XML
  end
end
