require 'test_helper'

class GuidanceGroupsControllerTest < ActionDispatch::IntegrationTest
  
  include Devise::Test::IntegrationHelpers

  # TODO: The following methods SHOULD replace the old 'admin_' prefixed methods. The routes file already has
  #       these defined. They are defined multiple times though and we need to clean this up! In particular
  #       look at the unnamed routes after 'new_plan_phase' below. They are not named because they are duplicates.
  #       We should just have:
  #
  # SHOULD BE:
  # --------------------------------------------------
  #   guidance_groups      GET    /guidance_groups        guidance_groups#index
  #                        POST   /guidance_groups        guidance_groups#create
  #   guidance_group       GET    /guidance_group/:id     guidance_groups#show
  #                        PATCH  /guidance_groups/:id    guidance_groups#update
  #                        PUT    /guidance_groups/:id    guidance_groups#update
  #                        DELETE /guidance_groups/:id    guidance_groups#destroy
  #
  # CURRENT RESULTS OF `rake routes`
  # --------------------------------------------------
  #   admin_show_guidance_group     GET      /org/admin/guidancegroup/:id/admin_show    guidance_groups#admin_show
  #   admin_new_guidance_group      GET      /org/admin/guidancegroup/:id/admin_new     guidance_groups#admin_new
  #   admin_edit_guidance_group     GET      /org/admin/guidancegroup/:id/admin_edit    guidance_groups#admin_edit
  #   admin_destroy_guidance_group  DELETE   /org/admin/guidancegroup/:id/admin_destroy guidance_groups#admin_destroy
  #   admin_create_guidance_group   POST     /org/admin/guidancegroup/:id/admin_create  guidance_groups#admin_create
  #   admin_update_guidance_group   PUT      /org/admin/guidancegroup/:id/admin_update  guidance_groups#admin_update

  setup do
    @user = org_admin_from(GuidanceGroup.first.org)
  end
  
  # GET /org/admin/guidancegroup/:id/admin_show (admin_show_guidance_group_path)
  # ----------------------------------------------------------
  test 'show the guidance_group' do
    # Should redirect user to the root path if they are not logged in!
    get admin_show_guidance_group_path(GuidanceGroup.find_by(org: @user.org))
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    get admin_show_guidance_group_path(GuidanceGroup.find_by(org: @user.org))
    assert_response :success
  end

  # GET /org/admin/guidancegroup/:id/admin_new (admin_new_guidance_group_path)
  # ----------------------------------------------------------
  test 'load the new guidance_group page' do
    # Should redirect user to the root path if they are not logged in!
    # TODO: Why is there an id here!? its a new guidance_group!
    get admin_new_guidance_group_path(@user.org)
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    get admin_new_guidance_group_path(@user.org)
    assert_response :success
  end
  
  # POST /org/admin/guidancegroup/:id/admin_create (admin_create_guidance_group_path)
  # ----------------------------------------------------------
  test 'create a new guidance_group' do
    params = {org_id: @user.org.id, published: false, name: 'Testing create'}
    
    # Should redirect user to the root path if they are not logged in!
    post admin_create_guidance_group_path(@user.org), {guidance_group: params}
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    post admin_create_guidance_group_path(@user.org), {guidance_group: params}
    assert_response :redirect
    assert_redirected_to admin_index_guidance_path(@user.org)
    assert_equal _('Guidance group was successfully created.'), flash[:notice]
    assert assigns(:guidance_group)
    
    # Invalid object
    post admin_create_guidance_group_path(@user.org), {guidance_group: {name: nil}}
    assert_response :redirect
    assert_redirected_to admin_new_guidance_group_path(@user.org)
    assert assigns(:guidance_group)
    assert flash[:notice].starts_with?(_('Unable to save your changes.'))
  end
  
  # GET /org/admin/guidancegroup/:id/admin_edit (admin_edit_guidance_group_path)
  # ----------------------------------------------------------
  test 'load the edit guidance_group page' do
    # Should redirect user to the root path if they are not logged in!
    get admin_edit_guidance_group_path(GuidanceGroup.find_by(org: @user.org))
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    get admin_edit_guidance_group_path(GuidanceGroup.find_by(org: @user.org))
    assert_response :success
  end
  
  # PUT /org/admin/templates/:id/admin_template (admin_update_guidance_group_path)
  # ----------------------------------------------------------
  test 'update the guidance_group' do
    params = {name: 'Testing UPDATE'}
    
    # Should redirect user to the root path if they are not logged in!
    put admin_update_guidance_group_path(GuidanceGroup.first), {guidance_group: params}
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    put admin_update_guidance_group_path(GuidanceGroup.first), {guidance_group: params}
    assert_response :redirect
    assert_redirected_to "#{admin_index_guidance_path(@user.org)}?name=Testing+UPDATE"
    assert_equal _('Guidance group was successfully updated.'), flash[:notice]
    assert assigns(:guidance_group)
    
    # Invalid object
    put admin_update_guidance_group_path(GuidanceGroup.first), {guidance_group: {name: nil}}
    assert_response :redirect
    assert_redirected_to admin_edit_guidance_group_path(GuidanceGroup.first)
    assert assigns(:guidance_group)
    assert flash[:notice].starts_with?(_('Unable to save your changes.'))
  end
  
  # DELETE /org/admin/guidancegroup/:id/admin_destroy (admin_destroy_guidance_group_path)
  # ----------------------------------------------------------
  test 'delete the guidance_group' do
    # Should redirect user to the root path if they are not logged in!
    delete admin_destroy_guidance_group_path(GuidanceGroup.first)
    assert_unauthorized_redirect_to_root_path
    
    sign_in @user
    
    delete admin_destroy_guidance_group_path(GuidanceGroup.first)
    assert_response :redirect
    assert_redirected_to admin_index_guidance_path
    assert_equal _('Guidance group was successfully deleted.'), flash[:notice]
  end
  
end