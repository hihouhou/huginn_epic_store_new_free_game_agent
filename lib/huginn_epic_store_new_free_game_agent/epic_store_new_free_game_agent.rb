module Agents
  class EpicStoreNewFreeGameAgent < Agent
    include FormConfigurable
    can_dry_run!
    no_bulk_receive!
    default_schedule 'every_1h'

    description do
      <<-MD
      The Epic Store new Free Game agent creates an event if a free game is available actually.

      `debug` is used to verbose mode.

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
        'debug' => 'false',
        'expected_receive_period_in_days' => '2',
        'changes_only' => 'true'
      }
    end

    form_configurable :expected_receive_period_in_days, type: :string
    form_configurable :changes_only, type: :boolean
    form_configurable :debug, type: :boolean

    def validate_options

      if options.has_key?('changes_only') && boolify(options['changes_only']).nil?
        errors.add(:base, "if provided, changes_only must be true or false")
      end

      if options.has_key?('debug') && boolify(options['debug']).nil?
        errors.add(:base, "if provided, debug must be true or false")
      end

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

    def log_curl_output(code,body)

      log "request status : #{code}"

      if interpolated['debug'] == 'true'
        log "body"
        log body
      end

    end

    def keep_only_max_ten()

      if memory['triggered'].present? && memory['triggered'].length > 10
        memory['triggered'] = memory['triggered'][-10..-1]
        if interpolated['debug'] == 'true'
          log "memory['triggered'] is cleaned now"
        end
      else
        if interpolated['debug'] == 'true'
          log "not enough record for already triggered offers"
        end
      end

    end

    def fetch
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

      log_curl_output(response.code, response.body)

      payload = JSON.parse(response.body)

      if !memory['triggered'].present?
        memory['triggered'] = []
      end

      if interpolated['changes_only'] == 'true'
        if payload != memory['last_status']
          if "#{memory['last_status']}" == ''
            payload['data']['Catalog']['searchStore']['elements'].each do |item|
              if interpolated['debug'] == 'true'
                log item
              end
              if !item['promotions'].nil?
                if !item['promotions']['promotionalOffers'].nil?
                  if !item['promotions']['promotionalOffers'].empty?
                    if !item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['startDate'].nil?
                      start_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['startDate']
                    end
                    if !item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['endDate'].nil?
                      end_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['endDate']
                    end
                    if !start_date.nil? && !end_date.nil? && Time.now.to_i.between?(Time.parse(start_date).to_i, Time.parse(end_date).to_i) && item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['discountSetting']['discountPercentage'] == 0
                      create_event payload: item
                      memory['triggered'] << item['id']
                    end
                  end
                end
              end
            end
          else
            last_status = memory['last_status']
            payload['data']['Catalog']['searchStore']['elements'].each do | item |
              found = false
              if interpolated['debug'] == 'true'
                log item
                log "found is #{found}"
              end
              if !item['promotions'].nil?
                if !item['promotions']['promotionalOffers'].nil?
                  if !item['promotions']['promotionalOffers'].empty?
                    if !item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['startDate'].nil?
                      start_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['startDate']
                    end
                    if !item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['endDate'].nil?
                      end_date = item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['endDate']
                    end
                    last_status['data']['Catalog']['searchStore']['elements'].each do | itembis|
                      if item['id'] == itembis['id'] && memory['triggered'].include?(item['id'])
                        found = true
                      end
                      if interpolated['debug'] == 'true'
                        log "found is #{found}"
                      end
                    end
                    if found == false && !start_date.nil? && !end_date.nil? && Time.now.to_i.between?(Time.parse(start_date).to_i, Time.parse(end_date).to_i) && item['promotions']['promotionalOffers'][0]['promotionalOffers'][0]['discountSetting']['discountPercentage'] == 0
                      create_event payload: item
                      if interpolated['debug'] == 'true'
                        log "adding #{item['id']} to triggered list"
                      end
                      memory['triggered'] << item['id']
                      log "event created"
                    else
                      if interpolated['debug'] == 'true'
                        log "event not created"
                      end
                    end
                    if !start_date.nil? && !end_date.nil? && !Time.now.to_i.between?(Time.parse(start_date).to_i, Time.parse(end_date).to_i)
                      if interpolated['debug'] == 'true'
                        log "removing #{item['id']} to triggered list"
                      end
                      memory['triggered'].delete(item['id'])
                    end
                  end
                end
              end
            end
          end
          memory['last_status'] = payload
        end
      else
        if payload != memory['last_status']
          memory['last_status']= payload
        end
        payload['data']['Catalog']['searchStore']['elements'].each do |item|
          create_event payload: item
        end
      end
      keep_only_max_ten()
    end
  end
end
