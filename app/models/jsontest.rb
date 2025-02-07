class Jsontest < ApplicationRecord
    jsonb_accessor :result, value: [array: true, default: []] 
end
