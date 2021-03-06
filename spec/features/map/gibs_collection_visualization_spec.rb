# EDSC-188 As a user, I want to view GIBS tile imagery corresponding to my
#          search area on a map so that I may preview my results
# EDSC-193 As a user, I want to see information about which collections have GIBS
#          support so I may understand why some collections render differently

require "spec_helper"

describe "Collection GIBS visualizations", reset: false do

  gibs_collection_id = 'C119124186-NSIDC_ECS'
  gibs_tile_layer = '.leaflet-tile-pane .leaflet-layer:nth-child(2)'

  before :all do
    load_page :search
    fill_in "keywords", with: gibs_collection_id
    expect(page).to have_content('AE_Rain')
  end

  after :all do
    reset_search
    wait_for_xhr
  end

  context "when viewing a GIBS-enabled collection in the results list" do
    it "indicates that the collection has GIBS visualizations" do
      expect(first_collection_result).to have_css('.badge-gibs')
    end
  end

  context "when visualizing a GIBS-enabled collection" do
    before :all do
      first_collection_result.click_link "View collection"
    end

    after :all do
      first_collection_result.click_link "Hide collection"
    end

    it "displays composite GIBS imagery corresponding to the first 20 granule results on an HTML canvas" do
      within gibs_tile_layer do
        expect(page).to have_selector('canvas')
      end
    end
  end

  context "when turning off visualizations for a GIBS-enabled collection" do
    before :all do
      first_collection_result.click_link "View collection"
      page.should have_css(gibs_tile_layer)
      first_collection_result.click_link "Hide collection"
    end

    it "removes the collection's GIBS tiles from the map" do
      page.should have_no_css(gibs_tile_layer)
    end
  end
end
