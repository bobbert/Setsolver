require File.dirname(__FILE__) + '/../test_helper'

class GamesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_game
    assert_difference('Game.count') do
      post :create, :game => { }
    end

    assert_redirected_to game_path(assigns(:game))
  end

  def test_should_show_game
    get :show, :id => games(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => games(:one).id
    assert_response :success
  end

  def test_should_update_game
    put :update, :id => games(:one).id, :game => { }
    assert_redirected_to game_path(assigns(:game))
  end

  def test_should_destroy_game
    assert_difference('Game.count', -1) do
      delete :destroy, :id => games(:one).id
    end

    assert_redirected_to games_path
  end
end
