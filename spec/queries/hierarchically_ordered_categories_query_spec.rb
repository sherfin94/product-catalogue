require 'rails_helper'

describe HierarchicallyOrderedCategoriesQuery do
  describe '#all' do
    it 'uses nested_set_options helper method, and returns the
      collection of first elements of the result' do

      place_holder_nested_set_options_result =
        [['place', 1], ['holder', 2]]

      expect(ActionController::Base.helpers)
        .to receive(:nested_set_options)
        .with(Category)
        .and_return(place_holder_nested_set_options_result)

      place_holder_collect_result = %w[place holder collect result]
      allow(place_holder_nested_set_options_result)
        .to receive(:collect)
        .and_return(place_holder_collect_result)

      expected_result = 'place_holder_final_result'
      allow(place_holder_collect_result)
        .to receive(:compact)
        .and_return(expected_result)

      result = described_class.new.all

      expect(result)
        .to eq expected_result
    end
  end

  describe '#non_empty' do
    it 'returns hierarchically ordered set of non-empty categories' do
      first_category, second_category, third_category =
        Array.new(3) { FactoryBot.create(:category) }
      second_category.move_to_child_of first_category
      third_category.move_to_child_of second_category
      [first_category, second_category].each do |category|
        category.products.push FactoryBot.create(:product)
      end

      result = HierarchicallyOrderedCategoriesQuery.new.non_empty

      expect(result.pluck :id).to eq [first_category, second_category].pluck :id
    end
  end
end
