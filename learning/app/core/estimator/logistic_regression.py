from sklearn.grid_search import GridSearchCV
from sklearn.linear_model import LogisticRegression as SkLogisticRegression
from app.shared.current_bot import CurrentBot
from app.shared.loader import Loader


class LogisticRegression:
    def __init__(self, bot=None, loader=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.loader = loader if loader is not None else Loader()
        self.estimator = self.loader.load(self.estimator_path)

    def fit(self, x, y):
        params = {'C': [10, 100, 140, 200]}
        grid = GridSearchCV(SkLogisticRegression(), param_grid=params)
        grid.fit(x, y)
        self.estimator = grid.best_estimator_
        self.loader.dump(self.estimator, self.estimator_path)

    def predict(self, question_features, _):
        results = self.estimator.predict_proba(question_features)
        return results[0]

    @property
    def estimator_path(self):
        return self.bot.dump_dirpath + '/logistic_regression_estimator'
