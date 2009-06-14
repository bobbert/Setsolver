# Adds constraints to applicable database tables.
# This script must get called AFTER all of the tables have been created, and
# should in almost all cases be the highest numbered script.
# (CHANGE NUMBERS WHEN ADDING NEW MODELS)
class AddConstraints < ActiveRecord::Migration
  # method to create SQL statement for adding or dropping foreign key constraint 
  # from table names in singular form.
  # THIS METHOD ONLY CREATES MYSQL-STYLE ADD AND DROP STATEMENTS.
  FK_SQL_FNC = lambda do |state, child, parent|
    if state == :up
      return 'ALTER TABLE ' + child.pluralize + ' ADD CONSTRAINT ' +
             parent + '_' + child + '_id_fkey ' + 'FOREIGN KEY (' + parent + '_id) ' +
             'REFERENCES ' + parent.pluralize + ' (id);'
    elsif state == :down
      return 'ALTER TABLE ' + child.pluralize + ' DROP FOREIGN KEY ' +
             parent + '_' + child + '_id_fkey;'
    end
  end

  def self.up
    ['number','shading','color','shape'].each do |tbl_nm|
      execute FK_SQL_FNC.call( :up, 'card', tbl_nm )
    end
    # association table FK's
    execute FK_SQL_FNC.call( :up, 'cards_deck', 'card' )
    execute FK_SQL_FNC.call( :up, 'cards_deck', 'deck' )
    execute FK_SQL_FNC.call( :up, 'cards_game', 'card' )
    execute FK_SQL_FNC.call( :up, 'cards_game', 'game' )
  end

  def self.down
    ['number','shading','color','shape'].each do |tbl_nm|
      execute FK_SQL_FNC.call( :down, 'card', tbl_nm )
    end
    # association table FK's
    execute FK_SQL_FNC.call( :down, 'cards_deck', 'card' )
    execute FK_SQL_FNC.call( :down, 'cards_deck', 'deck' )
    execute FK_SQL_FNC.call( :down, 'cards_game', 'card' )
    execute FK_SQL_FNC.call( :down, 'cards_game', 'game' )
  end
end