require 'spec_helper'

describe 'Workbook#with_data' do
  it 'no_data' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/with_data/no_data.xlsx')
    expect(xlsx).not_to be_with_data
  end

  it 'second_list' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/with_data/second_list.xlsx')
    expect(xlsx).to be_with_data
  end

  it 'text_in_cell' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/with_data/text_in_cell.xlsx')
    expect(xlsx).to be_with_data
  end
end
