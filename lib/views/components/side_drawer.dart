// ignore_for_file: unrelated_type_equality_checks, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_8_android/models/utils.dart';
import 'package:praktikum_8_android/views/components/drop_down_List.dart';

import '../../controllers/news_controller.dart';

Drawer sideDrawer(NewsController newsController) {
  return Drawer(
      child: ListView(
    padding: const EdgeInsets.symmetric(vertical: 60),
    children: [
      Container(
        child: GetBuilder<NewsController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.cName != ''
                      ? Text("Country = ${controller.cName.value}")
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  controller.category != ''
                      ? Text("Category = ${controller.category.value}")
                      : Container(),
                ],
              );
            },
            init: NewsController()),
      ),
      Container(
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: TextFormField(
              decoration: const InputDecoration(hintText: "Keyword"),
              scrollPadding: const EdgeInsets.all(5),
              onChanged: (val) {
                newsController.findNews.value = val;
                newsController.update();
              },
            ),
          )),
          MaterialButton(
              child: const Text('Search'),
              onPressed: () async {
                newsController.getNews(
                    searchKey: newsController.findNews.value);
              })
        ]),
      ),
      ExpansionTile(
        title: const Text("Country"),
        children: <Widget>[
          for (int i = 0; i < listOfCountry.length; i++)
            dropDownList(
                call: () {
                  newsController.country.value == listOfCountry[i]['code']!;
                  newsController.cName.value ==
                      listOfCountry[i]['name']!.toUpperCase();
                  newsController.getNews();
                },
                name: listOfCountry[i]['name']!.toUpperCase())
        ],
      ),
      ExpansionTile(
        title: const Text("Category"),
        children: <Widget>[
          for (int i = 0; i < listOfCategory.length; i++)
            dropDownList(
                call: () {
                  newsController.category.value == listOfCategory[i]['code']!;
                  newsController.getNews();
                },
                name: listOfCategory[i]['name']!.toUpperCase())
        ],
      ),
      ExpansionTile(
        title: const Text("Channel"),
        children: <Widget>[
          for (int i = 0; i < listOfNewsChannel.length; i++)
            dropDownList(
                call: () {
                  newsController.getNews(
                      channel: listOfNewsChannel[i]['code']!);
                },
                name: listOfNewsChannel[i]['name']!.toUpperCase())
        ],
      ),
      ListTile(
        title: const Text("Close"),
        onTap: () => Get.back(),
      )
    ],
  ));
}
