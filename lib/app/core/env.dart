import 'package:envied/envied.dart';

part 'env.g.dart';

/// Classe responsável por carregar variáveis de ambiente da aplicação.
///
/// Utiliza o pacote `envied` para gerar código seguro e evitar expor dados sensíveis.
/// As variáveis são definidas no arquivo `.env`, que deve estar na raiz do projeto.
@Envied(path: '.env')
abstract class Env {
  /// URL do projeto Supabase, definida na variável de ambiente `SUPABASE_URL`.
  ///
  /// Essa URL é usada para conectar o aplicativo ao backend do Supabase.
  @EnviedField(varName: 'SUPABASE_URL')
  static String supabaseUrl = _Env.supabaseUrl;

  /// Chave anônima da API do Supabase, definida na variável de ambiente `SUPABASE_ANON_KEY`.
  ///
  /// Essa chave permite o acesso público à API do Supabase (por exemplo, login e leitura de dados públicos).
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static String supabaseAnonKey = _Env.supabaseAnonKey;
}
