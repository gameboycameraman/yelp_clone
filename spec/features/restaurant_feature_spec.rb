require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: "Roast & Toast")
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Roast & Toast')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: "Roast & Toast"
      click_button 'Create Restaurant'
      expect(page).to have_content 'Roast & Toast'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'viewing restaurants' do
    let!(:roast){ Restaurant.create(name: 'Roast & Toast') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Roast & Toast'
      expect(page).to have_content 'Roast & Toast'
      expect(current_path).to eq "/restaurants/#{roast.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'Roast & Toast', description: 'Big, fat wrap of dreams', id: 1}
    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit Roast & Toast'
      fill_in 'Name', with: 'Roast and Toast'
      fill_in 'Description', with: "Big fat wrap of dreams"
      click_button 'Update Restaurant'
      click_link 'Roast and Toast'
      expect(page).to have_content "Roast and Toast"
      expect(page).to have_content "Big fat wrap of dreams"
      expect(current_path).to eq '/restaurants/1'
    end
  end
end
