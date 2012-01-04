class App
  module Views
    class Flist < Mustache
      @@have=nil
      def self.have(got)
        @@have=got
      end
      def self.rows(db, params)
	schema=params[:splat][0]
	table=params[:splat][1]

	data = { "total_undoc" => 0, "total_listing" => 0,
	  "table_schema" => schema, "table_name" => table,
	  "rows" => []}

	schema=db.escape(schema)
	table=db.escape(table)

	results=db.query("SELECT COUNT(*) AS undoc FROM field_definitions WHERE table_schema='#{schema}' AND table_name='#{table}' AND (notes IS NULL OR notes='') AND (status IS NULL OR status='')")
	results.each {|result| data['total_undoc']=result['undoc']}
	results=db.query("SELECT COUNT(*) AS total FROM field_definitions WHERE table_schema='#{schema}' AND table_name='#{table}'")
	results.each {|result| data['total_listing']=result['total']}

	results=db.query("SELECT table_schema, table_name, column_name, notes, CONCAT(table_schema, '.', table_name, '.', column_name) AS tkey FROM field_definitions WHERE table_schema='#{schema}' AND table_name='#{table}' AND (notes IS NULL OR notes='') AND (status IS NULL OR status='')")
	results.each do |row|

	  data['rows']<< { 'table_schema'=>row["table_schema"],
	    'table_name'=>row["table_name"], 'field_name'=>
	      row["column_name"],
	    'notes'=>row["notes"], 'link'=>
	      "<a href='#{row["tkey"]}'>Edit</a>",
	    'key'=>row["tkey"] }
	end
	data
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
