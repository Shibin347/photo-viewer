import 'package:flutter/material.dart';
import 'package:photo_viewer/model/image_model.dart';
import 'package:photo_viewer/screens/full_view_screen.dart';
import 'package:photo_viewer/services/http_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController _controller = ScrollController();
  dynamic page = 1;
  String? searchTerm;
    ImageModel? imageModel;
  bool isLoading = false;
  bool isLoadMore = false;
  List images = [];

  Future<ImageModel?> getImage() async {
    final response = await HttpService().getImage(searchTerm, page);
    imageModel = ImageModel.fromJson(response.data);
    if(mounted)
    {
      images.addAll(List.generate(imageModel!.hits!.length, (index) => {
        "image":imageModel!.hits![index].previewURL!,
      }));
      print("our details are $images");
      setState(() {
        isLoadMore = false;
        isLoading = false;
        print("Image List___________________________________________");
        print(page);
        print(response.data);
      });
    }
    return null;
  }
  @override
  void initState() {
    // TODO: implement initState
    page = 1;
    isLoading = true;
    _controller..addListener(_loadMore);
    getImage();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    images.clear();
    super.dispose();
  }

  _loadMore(){
    if(page <= imageModel!.total){
      if(_controller.position.extentAfter <= 0 && isLoadMore== false){
        setState(() {
          isLoadMore = true;
          page ++ ;
          getImage();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width/1.4,
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: (){
                      searchTerm = textEditingController.text;
                      print(searchTerm);
                      images.clear();
                      isLoading = true;
                      getImage();
                      setState(() {

                      });
                    },
                    icon: const Icon(Icons.search)),
                hintText: "Search Image",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          ),
        ),
      ),
      body:(isLoading == true)?const Center(
        child: CircularProgressIndicator(),
      ): Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount:images.length,
                  itemBuilder: (context, index){
                return  GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FullViewScreen(imageUrl: images[index]["image"],)));
                  },
                  child: Container(
                    width: double.infinity,
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.network(images[index]["image"],fit: BoxFit.fitWidth,),
                      ),
                    ),
                  ),
                );
              }),
            ),
            (isLoadMore == true)?const Center(child: CircularProgressIndicator(),):Container(),
          ],
        ),
      ),
    );
  }
}
