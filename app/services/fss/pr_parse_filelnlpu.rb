# frozen_string_literal: true

# Запрос создания нового ЭЛН
class Fss::PrParseFilelnlpu < Fss::Application
  def initialize
    super
    @xml_data = File.read("#{Rails.root}/public/xml/pr_parse_filelnlpu.xml")
  end

  def call
    response = client.call(:pr_parse_filelnlpu, message: xml_data)
    pp response.body
  end
end

# response.rb:132:in `raise_soap_and_http_errors!':
# (soap:Client) Unmarshalling Error: cvc-elt.3.1:
# Attribute 'http://www.w3.org/2001/XMLSchema-instance,nil' must not appear on element 'mseInvalidLoss',
# because the {nillable} property of 'mseInvalidLoss' is false.  (Savon::SOAPFault)
