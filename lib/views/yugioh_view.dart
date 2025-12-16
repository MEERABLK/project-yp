import 'package:flutter/material.dart';
import 'package:projectyp/dependencies.dart';
import 'package:projectyp/pages.dart';
import 'package:share_plus/share_plus.dart';

class YugiohView extends StatefulWidget {
  final YugiohModel yugiohModel;

  const YugiohView({super.key, required this.yugiohModel});

  @override
  State<YugiohView> createState() => _YugiohViewState();
}

class _YugiohViewState extends State<YugiohView> {
  int likesCount = 0;
  bool isLiked = false;

  final CommentsViewModel commentsVM = CommentsViewModel();
  final TextEditingController commentController = TextEditingController();
  List<CommentItem> comments = [];

  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final LikesViewModel likesVM = LikesViewModel();

  // ✅ Use Yu-Gi-Oh unique id like HomeView
  String get cardId => widget.yugiohModel.id.toString();
  int get commentsCount => comments.length;

  @override
  void initState() {
    super.initState();
    fetchLikes();
    fetchComments();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void fetchComments() async {
    final data = await commentsVM.getComments(cardId);
    setState(() {
      comments = data;
    });
  }

  void submitComment() async {
    if (commentController.text.trim().isEmpty) return;
    if (userId == null) return;

    final comment = CommentItem(
      userId: userId!,
      username: FirebaseAuth.instance.currentUser?.email ?? "Anonymous",
      text: commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    await commentsVM.addComment(cardId, comment);
    commentController.clear();
    fetchComments();
  }

  void deleteComment(CommentItem comment) async {
    await commentsVM.deleteComment(cardId, comment);
    fetchComments();
  }

  void editComment(CommentItem comment) {
    final controller = TextEditingController(text: comment.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final newText = controller.text.trim();
              if (newText.isEmpty) return;

              await commentsVM.updateComment(cardId, comment, newText);
              Navigator.pop(context);
              fetchComments();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void fetchLikes() async {
    if (cardId.isEmpty) return;

    LikesModel? likes = await likesVM.getLikes(cardId);

    setState(() {
      likesCount = likes?.userIds.length ?? 0;
      isLiked = userId != null && (likes?.userIds.contains(userId) ?? false);
    });
  }

  void toggleLike() async {
    final uid = userId;
    if (uid == null) return;

    if (isLiked) {
      await likesVM.removeLike(cardId, uid);
      setState(() {
        isLiked = false;
        likesCount -= 1;
      });
    } else {
      await likesVM.addLike(cardId, uid);
      setState(() {
        isLiked = true;
        likesCount += 1;
      });
    }
  }

  void shareCard() {
    final c = widget.yugiohModel;

    final String text =
        "🃏 Check out this Yu-Gi-Oh card!\n\n"
        "Name: ${c.name}\n"
        "Type: ${c.type}\n\n"
        "${c.desc}\n\n"
        "Found on ProjectYP";

    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.yugiohModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2F4E), Color(0xFF9380D5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.68)),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 30),
            child: Column(
              children: [
                // Card content
                Container(
                  decoration: BoxDecoration(
                    color: HexColor("#5c2e1a"),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Type
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                card.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              card.type,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      // Image
                      Container(
                        height: 260,
                        width: double.infinity,
                        color: HexColor("#2c1b12"),
                        child: Image.network(
                          card.card_images.image_url_cropped,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 60, color: Colors.white),
                          ),
                        ),
                      ),

                      // Description
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          card.desc,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Likes / Comments count / Share bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 22,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              likesCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 6),
                          Text(
                            commentsCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: shareCard,
                        child: const _ActionItem(
                          icon: Icons.share,
                          label: "Share",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Comments section
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (comments.isEmpty)
                        const Text(
                          "No comments yet",
                          style: TextStyle(color: Colors.white54),
                        )
                      else
                        ...comments.map(
                              (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CommentItem(
                              username: c.username,
                              comment: c.text,
                              isOwner: c.userId == userId,
                              onDelete: () => deleteComment(c),
                              onEdit: () => editComment(c),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, color: Colors.white54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Add a comment...",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.purpleAccent),
                              onPressed: submitComment,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String username;
  final String comment;
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CommentItem({
    required this.username,
    required this.comment,
    required this.isOwner,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isOwner) ...[
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.white70),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                      onPressed: onDelete,
                    ),
                  ],
                ],
              ),
              Text(
                comment,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
