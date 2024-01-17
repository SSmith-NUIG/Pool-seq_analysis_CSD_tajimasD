import matplotlib.pyplot as plt
import pandas as pd


def manhatten_plot_cmh(df):

    df.CHR = df.CHR.astype('category')
    df.CHR = df.CHR.cat.set_categories(["LG1", "LG2", "LG3", "LG4", "LG5", "LG6", "LG7", "LG8",
                                                    "LG9", "LG10", "LG11", "LG12", "LG13", "LG14", "LG15", "LG16"])

    df['ind'] = range(len(df))
    df_grouped = df.groupby('CHR')

    # Create plot for the whole genome
    fig = plt.figure(figsize=(14, 8)) # Set the figure size
    ax = fig.add_subplot(111)
    colors = ['darkred','darkgreen','darkblue', 'gold']
    x_labels = []
    x_labels_pos = []

    for num, (name, group) in enumerate(df_grouped):
        group.plot(kind='scatter', x='ind', y='pi',color=colors[num % len(colors)], ax=ax, s=1)
        x_labels.append(name)
        x_labels_pos.append((group['ind'].iloc[-1] - (group['ind'].iloc[-1] - group['ind'].iloc[0])/2))
    ax.set_xticks(x_labels_pos)
    ax.set_xticklabels(x_labels)

    # set axis limits
    ax.set_xlim([0, len(df)])
    ax.set_ylim([-2.2, 2.2])

    # x axis label
    ax.set_xlabel('Chromosome')
    plt.title("CMH test for colour")
    # show the graph
    plt.show()

def abline(slope, intercept):
    axes = plt.gca()
    x_vals = np.array(axes.get_xlim())
    y_vals = intercept + slope * x_vals
    plt.plot(x_vals, y_vals, '--')

df_wild = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/wild_df_lg.csv", header=None)
df_wild

df_wild.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_wild)
plt.title("Tajimas D for wild colonies")
abline(0,-2)
abline(0,2)
##
df_managed = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/managed_df_lg.csv", header=None)

df_managed.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_managed)
plt.title("Tajimas D for managed colonies")
abline(0,-2)
abline(0,2)

##

df_treated = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/treated_df_lg.csv", header=None)

df_treated.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_treated)
plt.title("Tajimas D for treated colonies")
abline(0,-2)
abline(0,2)
##
df_untreated = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/untreated_df_lg.csv", header=None)


df_untreated.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_untreated)
plt.title("Tajimas D for untreated colonies")
abline(0,-2)
abline(0,2)
##
df_hybrid = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/hybrid_df_lg.csv", header=None)


df_hybrid.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_hybrid)
plt.title("Tajimas D for hybrid colonies")
abline(0,-2)
abline(0,2)

##
df_pure = pd.read_csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/pure_df_lg.csv", header=None)

df_pure.columns = ["ind", "CHR", "POS", "pi"]
manhatten_plot_cmh(df_pure)
plt.title("Tajimas D for pure colonies")
abline(0,-2)
abline(0,2)


## max n min
# wild managed treated untreated hybrid pure

max(df_wild["pi"])
df_wild[df_wild['pi'] == max(df_wild["pi"])]
min(df_wild["pi"])
df_wild[df_wild['pi'] == min(df_wild["pi"])]


max(df_managed["pi"])
df_managed[df_managed['pi'] == max(df_managed["pi"])]
min(df_managed["pi"])
df_managed[df_managed['pi'] == min(df_managed["pi"])]


max(df_treated["pi"])
df_treated[df_treated['pi'] == max(df_treated["pi"])]
min(df_treated["pi"])
df_treated[df_treated['pi'] == min(df_treated["pi"])]


max(df_untreated["pi"])
df_untreated[df_untreated['pi'] == max(df_untreated["pi"])]
min(df_untreated["pi"])
df_untreated[df_untreated['pi'] == min(df_untreated["pi"])]


max(df_hybrid["pi"])
df_hybrid[df_hybrid['pi'] == max(df_hybrid["pi"])]
df_hybrid[df_hybrid['POS']==103000]

min(df_hybrid["pi"])
df_hybrid[df_hybrid['pi'] == min(df_hybrid["pi"])]


max(df_pure["pi"])
df_pure[df_pure['pi'] == max(df_pure["pi"])]
min(df_pure["pi"])
df_pure[df_pure['pi'] == min(df_pure["pi"])]
