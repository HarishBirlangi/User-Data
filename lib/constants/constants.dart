const usersDataRoute = '/UsersData/';
const addUserData = '/AddUserData/';
const webViewPageRoute = '/WebViewPage/';
const usersDataBoxName = 'userDataBox';

class AddUserDataPageArguments {
  final bool userDataEdit;
  final int? index;
  AddUserDataPageArguments({
    this.userDataEdit = false,
    this.index,
  });
}
