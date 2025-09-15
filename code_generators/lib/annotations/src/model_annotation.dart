const KiyuModelOptionDrift = 'drift';
const KiyuModelOptionFirebase = 'firebase';
const KiyuModelOptionServer = 'server';

class KiyuModel {  
  const KiyuModel({this.options = const [
    KiyuModelOptionDrift,
    KiyuModelOptionFirebase,
    KiyuModelOptionServer
  ]});  

  final List<String> options;
}


