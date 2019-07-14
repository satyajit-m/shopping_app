import 'package:flutter/material.dart';

class ServicesList extends StatelessWidget {
  final List<String> services;
  ServicesList(this.services);

  Widget _buildServiceItem(BuildContext context, int index) {
    return CategoryCard(services[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildServiceItem,
      itemCount: services.length,
    );
  }
}

class CategoryCard extends StatelessWidget {

  final String cardName;

  CategoryCard(this.cardName);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(cardName, textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}