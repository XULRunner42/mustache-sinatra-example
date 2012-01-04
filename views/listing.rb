class App
  module Views
    class Listing < Mustache
      @@data=
    { "total_undoc" => 65, "total_listing" => 70,
      "table_schema" => 'mmi1', # TODO: document the other schemas
      "rows" => [
#	{ "table" => 'Active_Queue_Main', "doc" => '35',
#	  "undoc" => '75', "total" => '110', key =>
#	  'mmi1.Active_Queue_Main'},
#	{ "table" => 'Final', "doc" => '75',
#	  "undoc" => '35', "total" => '110', key =>
#	  'mmi1.Final'}
      ] # Example rows
    } # Data type/default content of a listing
      @@have=nil
      def self.data(db, params)
	@@data["table_schema"]=db.escape(params['table_schema'])
# View shows detail of each table that has fields meeting criteria
# for determining undocumented fields in the records mentioned.
	results = db.query("SELECT COUNT(DISTINCT table_name) AS listing FROM field_definitions WHERE table_schema='#{@@data['table_schema']}'")
	results.each do |row|
	  @@data["total_listing"]=row['listing']
	end

	results = db.query("SELECT COUNT(DISTINCT table_name) AS undoc, table_name, column_name FROM field_definitions WHERE (status IS NULL or status='') AND (notes IS NULL or notes='') AND table_schema='#{@@data['table_schema']}'")
	results.each do |row|
	  @@data["total_undoc"]=row['undoc']
	end
	results = db.query("SELECT DISTINCT table_name FROM field_definitions WHERE (status IS NULL or status='') AND (notes IS NULL or notes='') AND table_schema='#{@@data['table_schema']}'")
	results.each do |row|
	  doc=nil
	  undoc=nil
	  result={ "table" => row['table_name'] }
	  table_name=db.escape(row['table_name'])
	  results_sub = db.query("SELECT COUNT(*) AS undoc FROM field_definitions WHERE (status IS NULL or status='') AND (notes IS NULL or notes='') AND table_schema='#{@@data['table_schema']}' AND table_name='#{table_name}'")
	  results_sub.each do |sub|
	    result["undoc"] = sub["undoc"]
	  end
	  results_sub = db.query("SELECT COUNT(*) AS doc FROM field_definitions WHERE NOT (status IS NULL AND notes IS NULL AND table_schema='mmi1') AND table_name='#{table_name}'")
	  results_sub.each do |sub|
	    result["doc"] = sub["doc"]
	  end
	  results_sub = db.query("SELECT CONCAT(table_schema, '.', table_name) AS tkey FROM field_definitions WHERE status IS NULL AND notes IS NULL AND table_schema='mmi1' AND table_name='#{table_name}'")
	  results_sub.each do |sub|
	    result["key"] = sub['tkey']
	  end
	  result["total"] = result["doc"] + result["undoc"]
	  @@data["rows"] << result
	end
	@@data
      end
      def self.have(got)
        @@have=got
      end
      def have
        !@@have.nil?
      end
      def got
        @@have
      end
    end
  end
end
