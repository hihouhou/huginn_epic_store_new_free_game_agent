module Agents
  class EpicStoreNewFreeGameAgent < Agent
    include FormConfigurable
    can_dry_run!
    no_bulk_receive!
    default_schedule '1h'

    description do
      <<-MD
      The Epic Store new Free Game agent creates an event if a free game is available actually.

      `expected_receive_period_in_days` is used to determine if the Agent is working. Set it to the maximum number of days
      that you anticipate passing without this Agent receiving an incoming Event.
      MD
    end

    event_description <<-MD
      Events look like this:
        {
          "title": "RollerCoaster Tycoon® 3: Complete Edition",
          "id": "4ec50a302f1449b3bf706a199c333ab8",
          "namespace": "f01b3e0178d448f0b93911e292d8e614",
          "description": "RollerCoaster Tycoon® 3: Complete Edition",
          "effectiveDate": "2020-09-24T15:00:00.000Z",
          "keyImages": [
            {
              "type": "OfferImageWide",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S5-1920x1080-689d96ca4d5a4e8de183b7a928960c87.jpg"
            },
            {
              "type": "OfferImageTall",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S6-1200x1600-591ca93f3bee7bc55a90b77ccc36eb84.jpg"
            },
            {
              "type": "DieselStoreFrontWide",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S5-1920x1080-689d96ca4d5a4e8de183b7a928960c87.jpg"
            },
            {
              "type": "DieselStoreFrontTall",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S6-1200x1600-591ca93f3bee7bc55a90b77ccc36eb84.jpg"
            },
            {
              "type": "Thumbnail",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S6-1200x1600-591ca93f3bee7bc55a90b77ccc36eb84.jpg"
            },
            {
              "type": "CodeRedemption_340x440",
              "url": "https://cdn1.epicgames.com/f01b3e0178d448f0b93911e292d8e614/offer/EGS_RollerCoasterTycoon3CompleteEdition_FrontierDevelopments_S6-1200x1600-591ca93f3bee7bc55a90b77ccc36eb84.jpg"
            }
          ],
          "seller": {
            "id": "o-mlnjydnrxlmer2ducb6u6ngznq25mx",
            "name": "Frontier Developments"
          },
          "productSlug": "rollercoaster-tycoon-3-complete-edition/home",
          "urlSlug": "mainegeneralaudience",
          "url": null,
          "items": [
            {
              "id": "d666b5e22c58413ebcf10a028d2364ee",
              "namespace": "f01b3e0178d448f0b93911e292d8e614"
            }
          ],
          "customAttributes": [
            {
              "key": "com.epicgames.app.blacklist",
              "value": "[]"
            },
            {
              "key": "publisherName",
              "value": "Frontier Foundry"
            },
            {
              "key": "developerName",
              "value": "Frontier Developments"
            },
            {
              "key": "com.epicgames.app.productSlug",
              "value": "rollercoaster-tycoon-3-complete-edition/home"
            }
          ],
          "categories": [
            {
              "path": "freegames"
            },
            {
              "path": "games"
            },
            {
              "path": "games/edition/base"
            },
            {
              "path": "games/edition"
            },
            {
              "path": "applications"
            }
          ],
          "tags": [
            {
              "id": "1393"
            },
            {
              "id": "1115"
            },
            {
              "id": "9547"
            }
          ],
          "price": {
            "totalPrice": {
              "discountPrice": 0,
              "originalPrice": 1999,
              "voucherDiscount": 0,
              "discount": 1999,
              "currencyCode": "EUR",
              "currencyInfo": {
                "decimals": 2
              },
              "fmtPrice": {
                "originalPrice": "19,99 €",
                "discountPrice": "0",
                "intermediatePrice": "0"
              }
            },
            "lineOffers": [
              {
                "appliedRules": [
                  {
                    "id": "cbda333590a14a55a8e1edbf6b7b6b1b",
                    "endDate": "2020-10-01T15:00:00.000Z",
                    "discountSetting": {
                      "discountType": "PERCENTAGE"
                    }
                  }
                ]
              }
            ]
          },
          "promotions": {
            "promotionalOffers": [
              {
                "promotionalOffers": [
                  {
                    "startDate": "2020-09-24T15:00:00.000Z",
                    "endDate": "2020-10-01T15:00:00.000Z",
                    "discountSetting": {
                      "discountType": "PERCENTAGE",
                      "discountPercentage": 0
                    }
                  }
                ]
              }
            ],
            "upcomingPromotionalOffers": [
      
            ]
          }
        }
    MD

    def default_options
      {
        'expected_receive_period_in_days' => '2',
      }
    end

    form_configurable :expected_receive_period_in_days, type: :string

    def validate_options

      unless options['expected_receive_period_in_days'].present? && options['expected_receive_period_in_days'].to_i > 0
        errors.add(:base, "Please provide 'expected_receive_period_in_days' to indicate how many days can pass before this Agent is considered to be not working")
      end
    end

    def working?
      event_created_within?(options['expected_receive_period_in_days']) && !recent_error_logs?
    end

    def check
      fetch
    end

    private

    def fetch
      require 'net/http'
      require 'uri'

      uri = URI.parse("https://store-site-backend-static.ak.epicgames.com/freeGamesPromotions?locale=fr&country=FR&allowCountries=FR")
      request = Net::HTTP::Get.new(uri)
      request["Authority"] = "store-site-backend-static.ak.epicgames.com"
      request["Accept"] = "application/json, text/plain, */*"
      request["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36"
      request["X-Requested-With"] = "XMLHttpRequest"
      request["Origin"] = "https://www.epicgames.com"
      request["Sec-Fetch-Site"] = "same-site"
      request["Sec-Fetch-Mode"] = "cors"
      request["Sec-Fetch-Dest"] = "empty"
      request["Referer"] = "https://www.epicgames.com/"
      request["Accept-Language"] = "fr,en-US;q=0.9,en;q=0.8"
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      
      log "request  status : #{response.code}"

      payload = JSON.parse(response.body)
      payload['data']['Catalog']['searchStore']['elements'].each do |item|
        if !item['promotions']['promotionalOffers'].blank?
          start_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['startDate']
          end_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['endDate']
#          puts start_date
#          puts end_date
#          puts Time.parse(start_date).to_i
#          puts Time.parse(end_date).to_i
          if Time.now.to_i.between?(Time.parse(start_date).to_i, Time.parse(end_date).to_i)
            create_event payload: item
          end
        end
      end
    end
  end
end
