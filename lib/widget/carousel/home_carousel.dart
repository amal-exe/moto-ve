import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeCarousel extends StatefulWidget {

  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() =>
      _HomeCarouselState();
}

class _HomeCarouselState
    extends State<HomeCarousel> {

  final CarouselSliderController
  _carouselController =
  CarouselSliderController();

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(

      stream: FirebaseFirestore.instance
          .collection('ads')
          .snapshots(),

      builder: (context, snapshot) {

        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {

          return const Center(
            child: Text(
              "No Ads Found",

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        final ads = snapshot.data!.docs;

        return CarouselSlider.builder(

          carouselController:
          _carouselController,

          itemCount: ads.length,

          options: CarouselOptions(

            height:
            width < 400 ? 180 : 200,

            autoPlay: true,

            viewportFraction: 1,

            enlargeCenterPage: false,

            autoPlayAnimationDuration:
            const Duration(
              milliseconds: 800,
            ),

            autoPlayInterval:
            const Duration(
              seconds: 3,
            ),

            pauseAutoPlayOnTouch: true,

            enableInfiniteScroll: true,
          ),

          itemBuilder:
              (context, index, realIndex) {

            final doc = ads[index];

            return Container(

              width: width,

              margin:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(15),

                boxShadow: [

                  BoxShadow(

                    color: Colors.white
                        .withOpacity(0.20),

                    blurRadius: 8,

                    spreadRadius: 1,
                  ),
                ],
              ),

              child: ClipRRect(

                borderRadius:
                BorderRadius.circular(15),

                child: Image.network(

                  doc['image'],

                  fit: BoxFit.cover,

                  width: double.infinity,

                  gaplessPlayback: true,

                  filterQuality:
                  FilterQuality.high,

                  loadingBuilder:
                      (
                      context,
                      child,
                      loadingProgress,
                      ) {

                    if (loadingProgress ==
                        null) {

                      return child;
                    }

                    return Container(

                      color:
                      Colors.black12,

                      child:
                      const Center(

                        child:
                        CircularProgressIndicator(),
                      ),
                    );
                  },

                  errorBuilder:
                      (
                      context,
                      error,
                      stackTrace,
                      ) {

                    return Container(

                      color:
                      Colors.black12,

                      child: const Icon(
                        Icons.broken_image,

                        color:
                        Colors.white,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}