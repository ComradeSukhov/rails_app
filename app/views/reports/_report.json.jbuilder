json.extract! report, :id, :name, :quantity, :type, :body, :created_at, :updated_at
json.url report_url(report, format: :json)
