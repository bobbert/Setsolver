require File.dirname(__FILE__) + '/../test_helper'

class GamesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, :player_id => players(:one).id
    assert_response :success
    assert_not_nil assigns(:games)
  end

  def test_should_get_new
    get :new, :player_id => players(:one).id
    assert_response :success
  end

  def test_should_create_game
    assert_difference('Game.count') do
      post :create, :player_id => players(:one).id, :game => { }
    end

    assert_redirected_to player_game_path(assigns(:player), assigns(:game))
  end

  def test_should_show_game
    get :show, :player_id => players(:one).id, :id => games(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :player_id => players(:one).id, :id => games(:one).id
    assert_response :success
  end

  def test_should_update_game
    put :update, :player_id => players(:one).id, :id => games(:one).id, :game => { }
    assert_redirected_to player_game_path(assigns(:player), assigns(:game))
  end

  def test_should_destroy_game
    assert_difference('Game.count', -1) do
      delete :destroy, :player_id => players(:one).id, :id => games(:one).id
    end

    assert_redirected_to player_games_path(assigns(:player))
  end
end
