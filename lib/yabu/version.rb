
# I hold information on the program version.
# I have only one class method.
# You have nothing to gain with instanciating me.
class Version
	@@shortName = 'yabu'
	@@major = '0'
	@@minor = '6'
	@@revision = 'recovery'
	@@tag = ''
	
	# @return [String] the complete version
	def Version.get
		ret = "#{@@shortName} #{@@major}.#{@@minor}.#{@@revision}"
		ret = "#{ret} (#{@@tag})" if @@tag.length > 0
		ret
	end
end
