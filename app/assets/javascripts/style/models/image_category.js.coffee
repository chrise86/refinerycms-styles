class Style.Models.ImageCategory extends Backbone.RelationalModel
  paramRoot: 'image_category'

  defaults:
    display_count: 1

  relations: [{
    type: 'HasMany'
    key: 'images'
    keyDestination: 'images_attributes'
    relatedModel: 'Style.Models.Image'
    collectionType: 'Style.Collections.Images'
    reverseRelation:
      key: 'image_category_id',
      includeInJSON: 'id'
  }]