class File {
  final int id;
  final String name;
  final String path;
  final List<int> fileData; 
  final double size;
  final int userId;
  final int folderId;
  final int nodeId;
  final int backNodeId;
  

  File({
    required this.id,
    required this.name,
    required this.path,
    required this.fileData,
    required this.size,
    required this.userId,
    required this.folderId,
    required this.nodeId,
    required this.backNodeId,
    
  });

  factory File.fromJson(Map<String, dynamic> json) {
    final List<int> fileData = (json['fileData'] as List).cast<int>();
    return File(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      fileData: fileData,
      size: json['size'].toDouble(),
      userId: json['userId'],
      folderId: json['folderId'],
      nodeId: json['nodeId'],
      backNodeId: json['backNodeId'],
      
    );
  }
}
