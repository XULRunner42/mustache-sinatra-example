class App
  module Views
    class Fieldedit < Mustache
      @@have=nil
      def self.have(got)
        @@have=got
      end
      def have
        !@@have.nil?
      end
      def got
        @@have
      end
      def self.update(db, record)
	schema=record["schema"]
	table=record["table"]
	column=record["column"]
	notes=record["notes"]
	status=record["status"]

	results=db.query("UPDATE field_definitions SET notes='#{notes}', status='#{status}' WHERE table_schema='#{schema}' AND table_name='#{table}' AND column_name='#{column}'")
	# Check for error status maybe?
      end
      def self.row(db, params)
	data=nil
	if ! params[:splat].nil?
	  schema=params[:splat][0]
	  table=params[:splat][1]
	  column=params[:splat][2]

	  data={
	    "schema" => schema,
	    "table" => table,
	    "column" => column,
	    "row"=>{} }
	  results=db.query("SELECT notes, status FROM field_definitions WHERE table_schema='#{schema}' AND table_name='#{table}' AND column_name='#{column}'")
	  results.each do |row|
	    data["row"]=row
	  end
	end
	data
      end
    end
  end
end
