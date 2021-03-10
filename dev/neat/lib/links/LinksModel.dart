import 'package:Neat/BaseModel.dart';

LinksModel linksModel = LinksModel();

class Link {
  int id;
  String actLink;
  String description;
  bool completed = false;

  bool hasLink() {
    return actLink != null;
  }
}

class LinksModel extends BaseModel<Link> with LinkSelection {}