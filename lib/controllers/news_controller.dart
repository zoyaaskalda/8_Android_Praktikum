import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_8_android/models/news_model.dart';
import '../models/article_model.dart';
import '../models/utils.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  List<Article> news = <Article>[];
  ScrollController scrollController = ScrollController();
  RxBool notFound = false.obs;
  RxBool isLoading = false.obs;

  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString findNews = ''.obs;

  RxInt pageNum = 1.obs;
  RxInt pageSize = 10.obs;
  dynamic isSwitched = false.obs;
  dynamic isPageLoading = false.obs;

  String _baseApi = baseApi;
  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_scrollListener);
    getNews();
    super.onInit();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading.value = true;
      update();
    }
  }

  getNews({channel = '', searchKey = '', reload = false}) async {
    notFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
    }

    if (isLoading.value == true) {
      pageNum++;
    } else {
      news = [];
      pageNum.value = 1;
    }
    _baseApi = "${_baseApi}pageSize=10&page=$pageNum&";
    _baseApi += country.value == '' ? 'country=id&' : 'country=$country';
    _baseApi += category.value == '' ? '' : 'category=$category';
    _baseApi += 'apiKey=$apiKey';

    if (channel != '') {
      country.value = '';
      category.value = '';
      _baseApi =
          "${_baseApi}pageSize=10&page=$pageNum&sources=$channel&apiKey=$apiKey";
    }
    if (searchKey != '') {
      country.value = '';
      category.value = '';
      _baseApi =
          "${_baseApi}pageSize=10&page=$pageNum&q=$searchKey&apiKey=$apiKey";
    }
    print(_baseApi);
    getDataFromApi(_baseApi);
  }

  changeTheme(value) {
    Get.changeTheme(value == true ? ThemeData.dark() : ThemeData.light());
    isSwitched = value;
    update();
  }

  getDataFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.newsFromJson(res.body);
      if (newsData.articles.isEmpty && newsData.totalResults == 0) {
        notFound.value = isLoading.value = true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          news = [...news, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.isNotEmpty) {
            news = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
      }
      notFound.value = false;
      isLoading.value = false;
      update();
    } else {
      notFound.value = true;
    }
  }
}
