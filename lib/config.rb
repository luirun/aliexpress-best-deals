class AliConfig

	def api_key
		api_key = "52761"
	end

	def api_signature
		api_signature = "h3dufVsxuo"
	end

	def alibaba_api_calls 
		alibaba_api_calls = {
			'list': 'api.listPromotionProduct',
			'details': 'api.getPromotionProductDetail',
			'links': 'api.getPromotionLinks',
			'similar-products': 'api.listSimilarProducts'
		}
	end
	
	def alibaba_api_params
		alibaba_api_params = {
			'list': [
				'fields',
				'keywords',
				'categoryId',
				'originalPriceFrom',
				'originalPriceTo',
				'volumeFrom',
				'volumeTo',
				'pageNo',
				'pageSize',
				'sort',
				'startCreditScore',
				'endCreditScore'
			],
			'details': [
				'fields',
				'productId'
			],
			'links': [
				'fields',
				'trackingId',
				'urls'
			]
		}
	end

	def alibaba_api_fields
		alibaba_api_fields = {
		'list': [
			'totalResults',
			'productId',
			'productTitle',
			'productUrl',
			'imageUrl',
			'originalPrice',
			'salePrice',
			'discount',
			'evaluateScore',
			'commission',
			'commissionRate',
			'30daysCommission',
			'volume',
			'packageType',
			'lotNum',
			'validTime',
			'commissionRate'
		],
		'details': [
			'productId',
			'productTitle',
			'productUrl',
			'imageUrl',
			'originalPrice',
			'salePrice',
			'discount',
			'evaluateScore',
			'commission',
			'commissionRate',
			'30daysCommission',
			'volume',
			'packageType',
			'lotNum',
			'validTime',
			'storeName',
			'storeUrl'
		],
		'links': [
			'totalResults',
			'trackingId',
			'publisherId',
			'url',
			'promotionUrl'
		]
		}
	end

end