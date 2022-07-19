import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:praktikum_8_android/controllers/news_controller.dart';
import 'package:praktikum_8_android/views/components/side_drawer.dart';
import 'package:praktikum_8_android/views/components/view_news.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  NewsController newsController = Get.put(NewsController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("News App"),
          actions: [
            IconButton(
                onPressed: (() {
                  newsController.country.value = '';
                  newsController.category.value = '';
                  newsController.findNews.value = '';
                  newsController.cName.value = '';
                  newsController.getNews(reload: true);
                  newsController.update();
                }),
                icon: const Icon(Icons.refresh)),
            GetBuilder<NewsController>(
                builder: (controller) => Switch(
                      value: controller.isSwitched == true ? true : false,
                      onChanged: (value) => controller.changeTheme(value),
                      activeColor: Colors.yellow,
                      activeTrackColor: Colors.red,
                    ),
                init: NewsController())
          ],
        ),
        drawer: sideDrawer(newsController),
        body: GetBuilder<NewsController>(
            builder: (controller) {
              return controller.notFound.value
                  ? const Center(
                      child:
                          Text('Not found..', style: TextStyle(fontSize: 30)))
                  : controller.news.length == 0
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: GestureDetector(
                                            onTap: () => Get.to(ViewNews(
                                                newsUrl: controller
                                                    .news[index].url)),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Column(children: [
                                                Stack(
                                                  children: [
                                                    controller.news[index]
                                                                .urlToImage ==
                                                            null
                                                        ? Container()
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                CachedNetworkImage(
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        // ignore: avoid_unnecessary_containers
                                                                        Container(
                                                                            child:
                                                                                const CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(Icons
                                                                            .error),
                                                                    imageUrl: controller
                                                                            .news[index]
                                                                            .urlToImage ??
                                                                        ''),
                                                          ),
                                                    Positioned(
                                                        bottom: 8,
                                                        right: 8,
                                                        child: Card(
                                                          elevation: 0,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor
                                                              .withOpacity(0.8),
                                                          child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8),
                                                              child: Text(
                                                                  "${controller.news[index].source.name}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2)),
                                                        ))
                                                  ],
                                                ),
                                                const Divider(),
                                                Text(
                                                    "${controller.news[index].title}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10))
                                              ]),
                                            )))),
                                index == controller.news.length - 1 &&
                                        controller.isLoading == true
                                    ? Center(child: CircularProgressIndicator())
                                    : SizedBox()
                              ],
                            );
                          },
                          itemCount: controller.news.length,
                        );
            },
            init: newsController));
  }
}
