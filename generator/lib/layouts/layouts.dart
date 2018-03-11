library bare.layout;

import 'package:stencil/stencil.dart';
import 'package:jaguar_martini/jaguar_martini.dart';

import '../partials/partials.dart';

class SiteLayout implements SiteRenderer {
  @override
  List<String> index(Site site) => [
        '''
<html>
  ${new HeadComp(site).render()}

  <body>
    <main>
      <div class="intro">
          <h1>${site.meta.title}</h1>
          <h2>${site.meta.description}</h2>
      </div>
    </main>
    
    <footer>
      <p class="copyright text-muted">${site.meta.copyright}</p>
    </footer>
  </body>
</html>
    '''
      ];

  @override
  List<String> categories(Category categories) => [];

  @override
  List<String> tags(Tag tags) => [];

  /// Renders single pages of the section
  @override
  String sectionSingle(SinglePage page) => '''
<html>
  ${new HeadComp(page).render()}
  <body>
    ${page.content}
  </body>
</html>
  ''';

  /// Renders list pages of the section
  @override
  List<String> sectionIndex(ListPage page) =>
      <String>[new SectionIndexGenerator(page).render()];

  @override
  List<String> sectionTags(Tag tag) => [];

  @override
  List<String> sectionCategories(Category cat) => [];
}

class SectionIndexGenerator extends Component {
  final ListPage page;

  SectionIndexGenerator(this.page);

  Site get site => page.site;

  String get heading {
    if (page is Tag) {
      return (page as Tag).name;
    } else if (page is Category) {
      return (page as Category).name;
    } else if (page is Section) {
      return (page as Section).name;
    } else if (page is Site) {
      return (page as Site).meta.title;
    }
    throw new UnsupportedError('Unsupported list page!');
  }

  @override
  String render() {
    return '''
<html>
  ${comp(new HeadComp(page))}

  <body>
    <header class="site">
      <div class="title"><a href="${site.meta.baseURL}">${site.meta.title}</a></div>
    </header>

    <div class="container site">

    <div class="list">
      <header class="list-title"><h1>$heading</h1></header>

      <div class="row">
        <div class="col-sm-9">
          <div class="articles">
            ${forEach(page.pages,
            (i) => new PostsListItemPartial(page.pages[i]).render())}
          </div>

          <!-- TODO {{ partial "pagination.html" . }} -->
        </div>
        <div class="col-sm-3 sidebar">
          ${comp(new SidebarComp(page))}
        </div>
      </div>
    </div>
    <!-- TODO {{ partial "default_foot.html" . }} -->
  </body>
</html>
    ''';
  }
}
