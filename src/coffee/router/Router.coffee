class Router extends Backbone.Router

	routes :
		'(/):area(/)'     : 'hashChanged'
		'(/):area/:id(/)' : 'hashChanged'
		'*actions'        : 'hashChanged'

	start: ->
		Backbone.history.start 
			pushState: true, 
			root: ''

		return null

	hashChanged : (area = null, sub = null) =>
		console.log(area, sub)

		null

	navigateTo : (where, trigger = true) =>

		where = '/' if where is undefined

		if where.charAt( where.length - 1 ) != '/'
			where += '/'

		@navigate where, trigger: trigger

		return null