Template.postsList.helpers
  posts: Posts.find {}, @projection

  postsWithRank: ->
    do @posts.rewind

    @posts.map (post, index) ->
      post._rank = index
      post
