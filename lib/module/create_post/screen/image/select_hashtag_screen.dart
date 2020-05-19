import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/module/create_post/screen/image/seletec_hashtag_bloc.dart';
import 'package:whatsup/utils/number_utils.dart';
import 'package:whatsup/utils/widgets/w_text_widget.dart';

class SelectHashTag extends StatefulWidget {
  final Function(List<String>) callBackSave;

  const SelectHashTag({Key key, this.callBackSave}) : super(key: key);

  static Widget newInstance(
      {Function(List<String>) callBackSave, List<String> orginalListHashTag}) {
    return BlocProvider<SelectHashTagBloc>(
      creator: (_context, _bag) => SelectHashTagBloc(orginalListHashTag),
      child: SelectHashTag(
        callBackSave: callBackSave,
      ),
    );
  }

  @override
  _SelectHashTagState createState() => _SelectHashTagState();
}

class _SelectHashTagState extends State<SelectHashTag> {
  SelectHashTagBloc _bloc;

  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _bloc = BlocProvider.of<SelectHashTagBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const WText('edit tags'),
            backgroundColor: Colors.black,
            leading: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ))),
            actions: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        widget.callBackSave(_bloc.getTagsChoossed());
                      },
                      behavior: HitTestBehavior.opaque,
                      child: WText(
                        'save',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            ]),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Container(
        child: Column(
      children: <Widget>[_buildShowTags(), _buildListTags()],
    ));
  }

  Widget _buildListTags() {
    return Expanded(
        child: Container(
      child: StreamBuilder<List<HashTagModel>>(
          stream: _bloc.listTagSortStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (lengthTags < 20) {
                        lengthTags++;
                        _bloc.onUserEnter(snapshot.data[index].name);
                        _textEditingController.text = '';

                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(children: <Widget>[
                        const WText(
                          '#',
                          size: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: WText(
                            snapshot.data[index].name,
                            size: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WText(
                          NumberUtils.handleNumber(
                              snapshot.data[index].count.toString()),
                          size: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ]),
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              ),
            );
          }),
    ));
  }

  int lengthTags = 0;

  Widget _buildShowTags() {
    return StreamBuilder<List<String>>(
        stream: _bloc.tagStream,
        builder: (context, snapshot) {
          // ignore: always_put_control_body_on_new_line
          return Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 0),
                child: Container(
                  margin: const EdgeInsets.only(left: 0, right: 32),
                  child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: buildHashTagChoosed(snapshot.data)),
                ),
              ),
              Positioned(
                  right: 16,
                  child: WText(
                    '${!snapshot.hasData ? 20 : 20 - snapshot.data.length}',
                    fontWeight: FontWeight.bold,
                  ))
            ],
          );
        });
  }

  List<Widget> buildHashTagChoosed(List data) {
    List<Widget> _temp = List();
    var length = data?.length ?? 0;
    for (var i = 0; i < length; i++) {
      _temp.add(GestureDetector(
        onTap: () {
          _bloc.removeHashTags(i);
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          margin: const EdgeInsets.only(right: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: <Widget>[
                Text(
                  '#${data[i].toString()}',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                  size: 13,
                )
              ],
            ),
          ),
        ),
      ));
    }
    // ignore: cascade_invocations
    _temp.add(Container(
      width: 100,
      child: TextField(
        focusNode: _focusNode,
        controller: _textEditingController,
        onChanged: (data) {
          _bloc.onUserChangeText(data);
        },
        onSubmitted: (data) {
          if (data.length <= 20) {
            lengthTags++;
            _bloc.onUserEnter(data);
            _textEditingController.text = '';
          }
        },
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    ));
    return _temp;
  }
}
