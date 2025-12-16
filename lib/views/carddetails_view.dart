import 'package:flutter/material.dart';
import 'package:projectyp/models/pokemon_model.dart';
import 'package:projectyp/pages.dart';
import 'package:projectyp/dependencies.dart';
import 'package:share_plus/share_plus.dart';

class CardDetailsView extends StatefulWidget {
  final PokemonModel pokemon;



  const CardDetailsView({super.key, required this.pokemon});

  @override
  State<CardDetailsView> createState() => _CardDetailsViewState();
}

class _CardDetailsViewState extends State<CardDetailsView> {
  int likesCount = 0;
  bool isLiked = false;

  int get commentsCount => comments.length;


  final CommentsViewModel commentsVM = CommentsViewModel();
  final TextEditingController commentController = TextEditingController();

  List<CommentItem> comments = [];

  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final LikesViewModel likesVM = LikesViewModel();

  @override
  void initState() {
    super.initState();
    fetchLikes();
    fetchComments();

  }

  int _stat(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
  void fetchComments() async {
    final data = await commentsVM.getComments(widget.pokemon.name);
    setState(() {
      comments = data;
    });
  }
  void shareCard() {
    final pokemon = widget.pokemon;

    final String text =
        " Check out this Pokémon!\n\n"
        "Name: ${pokemon.name}\n"
        "Types: ${pokemon.types.join(', ')}\n"
        "Abilities: ${pokemon.abilities.join(', ')}\n\n"
        "Found on ProjectYP ";

    Share.share(text);
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

    await commentsVM.addComment(widget.pokemon.name, comment);
    commentController.clear();
    fetchComments();
  }
  void deleteComment(CommentItem comment) async {
    await commentsVM.deleteComment(
      widget.pokemon.name,
      comment,
    );
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
              await commentsVM.updateComment(
                widget.pokemon.name,
                comment,
                controller.text.trim(),
              );
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
    if (widget.pokemon.name.isEmpty) return;

    LikesModel? likes = await likesVM.getLikes(widget.pokemon.name);

    setState(() {
      likesCount = likes?.userIds.length ?? 0;
      isLiked = userId != null && (likes?.userIds.contains(userId) ?? false);
    });
  }

  void toggleLike() async {
    final uid = userId;
    if (uid == null) return;

    if (isLiked) {
      await likesVM.removeLike(widget.pokemon.name, uid);
      setState(() {
        isLiked = false;
        likesCount -= 1;
      });
    } else {
      await likesVM.addLike(widget.pokemon.name, uid);
      setState(() {
        isLiked = true;
        likesCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hp = _stat(widget.pokemon.baseStats['hp']);
    final atk = _stat(widget.pokemon.baseStats['atk']);
    final def = _stat(widget.pokemon.baseStats['def']);
    final spa = _stat(widget.pokemon.baseStats['spa']);
    final spd = _stat(widget.pokemon.baseStats['spd']);
    final spe = _stat(widget.pokemon.baseStats['spe']);

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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.pokemon.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              widget.pokemon.types.join(', '),
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 260,
                        width: double.infinity,
                        color: Colors.yellow.shade100,
                        child: Image.network(
                          widget.pokemon.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image, size: 60)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Abilities: ${widget.pokemon.abilities.join(', ')}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "HP: $hp  ATK: $atk  DEF: $def",
                              style: const TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              "SpA: $spa  SpD: $spd  SPE: $spe",
                              style: const TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Likes bar (REAL)
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
                          const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
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

                      // Add comment input
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

                            // comment iconbutton
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
