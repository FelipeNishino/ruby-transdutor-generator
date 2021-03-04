class TransdutorGenerator
  def initialize
    @nEstados = 0
    @nEntradas = 0
    @source = []
    @line = ""
    @entradas = []
    @funcoes = []
    @qAceitavel = 0
  end
  attr_accessor :nEstados, :nEntradas, :source, :line, :entradas, :funcoes, :qAceitavel

  def addHeader
  	clearFile
  	@line = ""
  	@line << "class Transdutor" << 10
  	@source.push(line)
  end

  def clearFile
  	File.open('GeneratedTransdutor.rb', 'w') { |file| file.write("") }
  end

  def getEstados
    puts "Quantos estados seu automato possui?"
    @nEstados = Integer(gets.chomp)
    puts "Qual o estado aceitável?"
    @qAceitavel = Integer(gets.chomp)
  end

  def getEntradas(i)
  	@entradas = []
  	@funcoes = []
    puts "Quantas entradas o estado " << i.to_s << " aceita?(0 para considerar o else)"
    @nEntradas = Integer(gets.chomp)
    if @nEntradas != 0 
    	for j in 0...@nEntradas
  	  	puts "Qual character para a entrada " << (j+1).to_s << "?( = \"\", )"
  	  	@entradas.push(gets.chomp)
  	  	puts "Para qual estado ele leva?"
  	  	@funcoes.push(gets.chomp)
  	  end
  	end
  	  puts "Para qual estado \"else\" leva?"
  	  @funcoes.push(gets.chomp)
  end


  def generateTest
  	@line = ""
  	@line << "def test" << 10
		@line << "@results = Array.new" << 10
		@line << "@testData = [ \"carro\", \"varro\", \"cvrro\", \"cavro\", \"carvo\", \"carrv\", \"vvrro\", \"cvvro\", \"cavvo\", \"carvv\", \"vavro\", \"varvo\", \"varrv\", \"vrumm\", \"cvrvo\", \"cvrrv\", \"cavrv\", \"vvvro\", \"cvvvo\", \"cavvv\", \"vavrv\", \"vvvvo\", \"cvvvv\", \"vvrvv\", \"vvvvv\", \"carrov\"]" << 10
		@line << "for word in @testData" << 10
		@line << "	@chars = word.split(//)" << 10
		@line << "	@i = -1" << 10
		@line << "	iniciar" << 10
		@line << "	puts \"palavra testada \" << word" << 10
		@line << "	puts" << 10
		@line << "end" << 10

		@line << "@i = 0" << 10
		@line << "puts \"Resultados:\"" << 10
		@line << "for word in @testData" << 10
		@line << "	print word << \" \" << @results[@i].to_s" << 10
		@line << "	puts" << 10
		@line << "	@i += 1" << 10
		@line << "end" << 10
		@line << "end" << 10

		@line << "def step" << 10
		@line << "	@i += 1" << 10
		@line << "	if @i < @chars.count" << 10
		@line << "			@chars[@i]" << 10
		@line << "		else" << 10
		@line << "			\"\"" << 10
		@line << "	end" << 10
		@line << "end" << 10
		@line << "def iniciar" << 10
		@line << "  q0" << 10
		@line << "end" << 10

		@source.push(@line)
	end

  def generateFunc(i)
  	@line = ""
  	@line << "def q" << i.to_s << 10
  	@line << "puts \"Q" << i.to_s << "\"" << 10
  	@line << "case step" << 10
  	@line << "when \"\"" << 10
  	if i == @qAceitavel
  		@line << "puts \"Aceitou\"" << 10
  	else
  		@line << "puts \"Falhou\"" << 10
  	end
  	for j in 0...@nEntradas
  		@line << "when \"" << @entradas[j] << "\"" << 10
  		@line << "q" << @funcoes[j] << 10
  	end
  	@line << "else" << 10
  	@line << "q" + @funcoes[-1] << 10
  	@line << "end" << 10
  	@line << "end" << 10

  	@source.push(@line)
  end

  def writeFile
  	@line = ""
  	@line << 10 << "t = Transdutor.new" << 10
		@line << "t.test" << 10
		@source.push(@line)
  	for line in @source
  		File.open('GeneratedTransdutor.rb', 'a') { |file| file.write(line) }
  	end 
  	puts "Código gerado!"
  end
end

tg = TransdutorGenerator.new
tg.addHeader
tg.generateTest
tg.getEstados
for k in 0...tg.nEstados
	tg.getEntradas(k)
	tg.generateFunc(k)
end
tg.line = ""
tg.line << "end" << 10
tg.source.push(tg.line)
tg.writeFile

# implementar possibilidade de vários estados aceitáveis
# implementar controle do else
# implementar construtor
# tentar gerar o testData