class Project < ActiveRecord::Base
  has_many :needs
  has_many :savings
  has_many :actions
  has_and_belongs_to_many :users, :join_table => 'users_projects'

  validates_presence_of :name, :short_desc
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 100
  validates_length_of :short_desc, :maximum => 200

  acts_as_ferret :fields => {:name => {:store => :yes }, 
                             :short_desc => {:store => :yes}, 
                             :desc => {}}

  class << self
    def full_text_search(q, options = {})
      return nil if q.nil? or q==""
      default_options = {:limit => 10, :page => 1}
      options = default_options.merge options

      # get the offset based on what page we're on
      options[:offset] = options[:limit] * (options.delete(:page).to_i-1)  

      # now do the query with our options
      find_storage_by_contents(q, options)
    end

    def find_storage_by_contents(query, options = {})
      # Get the index that acts_as_ferret created for us
      index = self.aaf_index.ferret_index
      results = []

      # search_each is the core search function from Ferret, which Acts_as_ferret hides
      total_hits = index.search_each(query, options) do |doc, score| 
        result = {}

        # Store each field in a hash which we can reference in our views
        result[:id] = index[doc][:id] 
        result[:name] = index[doc][:name] 
        result[:short_desc] = index[doc][:short_desc]

        # We can even put the score in the hash, nice!
        result[:score] = score   

        results.push result
      end
      block_given? ? total_hits : [total_hits, results]
    end
  end

end
