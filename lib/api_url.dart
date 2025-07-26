class ApiUrl {
  static const baseUrl = 'http://127.0.0.1:3000/api';

  static const register = '/auth/register';

  static const refresh = '/auth/refresh';

  static const login = '/auth/login';

  static const requestOtp = '/auth/requestOtp';

  static const verifyOtp = '/auth/verifyOtp';

  static const changePsw = '/auth/changePsw';

  static const userinfo = '/user/info';

  static const checkSecret = '/author/sendOtp';

  static const authorOtp = '/author/verifyOtp';

  static const createBook = '/author/createBook';

  static const fetAllBook = '/author/allBook';

  static const logOut = '/auth/signOut';

  static const getAuthors = '/user/getAuthors';

  static const getAllAuthorsBooks = '/user/getAllAuthorsBooks';
}
