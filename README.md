## Usage 

```dart
AppendableListView<AdvertisementFeedModel, AdvertisementModel>(
    getPage: getFeed,
    itemBuilder: (context, models, index) {
    return CustomCard(
        item: models[index],
        onTap: () {
            HapticFeedback.lightImpact();
        });
    },
    onEmpty: Center(
        child: Text(
            "Oops! It's empty here...",
        ),
    ),
    loadingIndicator: LoadingWidget(),
),
```

